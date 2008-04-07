Return-Path: <linux-kernel-owner+w=401wt.eu-S1758619AbYDGNWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619AbYDGNWo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 09:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757328AbYDGNWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 09:22:36 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:26614 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435AbYDGNWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 09:22:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=QDCKSIprdXDjMaJbDIbq0vspIrcV9NfEaWiq5BtjBB8wku+DbkcVyiZwdFmFhsMVPVXsxNvi4HuUhF0TBjwfhiqCBLMhOay9JguWPNAdSA9P22wxo/6y1oe5MmnAvU7vWy3Hu8MwDomm8wf9GFSAXSUekRDNdhQd2YvMBqDnKjw=
Message-ID: <2f11576a0804070622j5cb39f90pb3e190d6153a5439@mail.gmail.com>
Date: Mon, 7 Apr 2008 22:22:34 +0900
From: "KOSAKI Motohiro" <m-kosaki@ceres.dti.ne.jp>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Subject: Re: [-mm] Disable the memory controller by default (v2)
Cc: andi@firstfloor.org, "Andrew Morton" <akpm@linux-foundation.org>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>,
       "Paul Menage" <menage@google.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, "Pavel Emelianov" <xemul@openvz.org>,
       hugh@veritas.com, "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080407130215.26565.81715.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080407130215.26565.81715.sendpatchset@localhost.localdomain>
X-Google-Sender-Auth: be0552e0fc2b1524
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  Changelog v1
>
>  1. Split cgroup_disable into cgroup_disable and cgroup_enable
>  2. Remove cgroup_toggle
>
>  Due to the overhead of the memory controller. The
>  memory controller is now disabled by default. This patch adds cgroup_enable.
>
>  If everyone agrees on this approach and likes it, should we push this
>  into 2.6.25?

Acked-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
