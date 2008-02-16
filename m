Return-Path: <linux-kernel-owner+w=401wt.eu-S1758959AbYBPRow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758959AbYBPRow (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 12:44:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755986AbYBPRoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 12:44:44 -0500
Received: from smtp-out.google.com ([216.239.45.13]:39996 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755328AbYBPRon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 12:44:43 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=wqUOMENP4nm7l/23jZpioiKNgX9LSTV1eZjKoxIR/9e8CMKHBoFHkayOeHJj/9ZU+
	Opi+N2A5aTyShYZQHnXAg==
Message-ID: <6599ad830802160944v6d529570k1ade6df273ca3d0d@mail.gmail.com>
Date: Sat, 16 Feb 2008 09:44:40 -0800
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH 1/7] CGroup API: Add cgroup.api control file
Cc: balbir@in.ibm.com, pj@sgi.com, "Pavel Emelianov" <xemul@openvz.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       vatsa@linux.vnet.ibm.com, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <47B6B5CA.7040201@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080215204418.535025000@menage.corp.google.com>
	 <20080215204820.734926000@menage.corp.google.com>
	 <47B6B5CA.7040201@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 16, 2008 2:07 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> Paul Menage wrote:
>
> Hi, Paul,
>
> Do we need to use a cgroup.api file? Why not keep up to date documentation and
> get users to use that. I fear that, cgroup.api will not be kept up-to-date,
> leading to confusion.

The cgroup.api file isn't meant to give complete documentation for a
control file, simply a brief indication of its usage.

The aim is that most bits of the information reported in cgroup.api
are auto-generated, so there shouldn't be problems with it getting
out-of-date.

Is it just the space used by the documentation string that you're
objecting to? The other function of the file is to declare a type for
each variable.

Paul
