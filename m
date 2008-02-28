Return-Path: <linux-kernel-owner+w=401wt.eu-S1763323AbYB1VlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763323AbYB1VlQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 16:41:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488AbYB1Vk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 16:40:59 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:48666 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751866AbYB1Vk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 16:40:58 -0500
Date: Thu, 28 Feb 2008 13:40:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Paul Menage" <menage@google.com>
Cc: containers@lists.osdl.org, linux-kernel@vger.kernel.org,
       balbir@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, xemul@openvz.org,
       pj@sgi.com
Subject: Re: [RFC] Prefixing cgroup generic control filenames with "cgroup."
Message-Id: <20080228134027.05b2aa87.akpm@linux-foundation.org>
In-Reply-To: <6599ad830802281328q162d0585v3ac6b45a119a4a05@mail.gmail.com>
References: <6599ad830802281314s25c033d6tc021725ae28aef8d@mail.gmail.com>
	<20080228132142.4d4b1eef.akpm@linux-foundation.org>
	<6599ad830802281328q162d0585v3ac6b45a119a4a05@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008 13:28:31 -0800
"Paul Menage" <menage@google.com> wrote:

> On Thu, Feb 28, 2008 at 1:21 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> 
> >
> >  Because if something is in /foo/bar/cgroup/notify_on_release then
> >  prefixing the filename with "cgroup_" seems pretty pointless.
> >
> 
> The point would be to avoid situations where a user has code that
> creates a group directory called "foo", and then in a future kernel
> release cgroups introduces a control file called "foo". If it's
> prefixed, then the user just has to avoid creating groups prefixed by
> "cgroup." or any subsystem name, so collisions will be less likely.
> 

Maybe cgroups shouldn't be putting kernel-generated files in places where
user-specified files appear?

(Am still thrashing around a bit here without an overview of the overall
layout and naming).

