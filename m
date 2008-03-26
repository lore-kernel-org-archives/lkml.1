Return-Path: <linux-kernel-owner+w=401wt.eu-S1761927AbYCZSwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761927AbYCZSwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 14:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754595AbYCZSwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 14:52:32 -0400
Received: from smtp-out.google.com ([216.239.33.17]:12301 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960AbYCZSwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 14:52:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Cfrc3Mw6t0s7iMka31C6dYaWkJHkiWnyxq0hGPNS4R1aokb9y7+1brAMW9M3radkZ
	/dIfE5nskhaHhhFMiTbbA==
Message-ID: <6599ad830803261152j1973e3c8oa82181a830f89260@mail.gmail.com>
Date: Wed, 26 Mar 2008 11:52:21 -0700
From: "Paul Menage" <menage@google.com>
To: "Balaji Rao" <balajirrao@gmail.com>
Subject: Re: [RFC][-mm] [2/2] Simple stats for memory resource controller
Cc: linux-kernel@vger.kernel.org, containers@lists.osdl.org, balbir@in.ibm.com,
       dhaval@linux.vnet.ibm.com
In-Reply-To: <200803262348.59785.balajirrao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803262348.59785.balajirrao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 11:18 AM, Balaji Rao <balajirrao@gmail.com> wrote:
>         [MEM_CGROUP_STAT_RSS] = { "rss", PAGE_SIZE, },
>  +       [MEM_CGROUP_STAT_PGIN_COUNT] = {"page_in_count", 1, },
>  +       [MEM_CGROUP_STAT_PGOUT_COUNT] = {"page_out_count", 1, },
>   };
>

Should these be called "pgpgin" and "pgpgout" for consistency with /proc/vmstat?

Paul
