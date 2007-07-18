Return-Path: <linux-kernel-owner+w=401wt.eu-S932907AbXGROok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932907AbXGROok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 10:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763665AbXGROoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 10:44:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54443 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755964AbXGROo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 10:44:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Parag Warudkar <parag.warudkar@gmail.com>
Subject: Re: 2.6.22 - Suspend and Weird Load Averages
Date: Wed, 18 Jul 2007 16:52:28 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <469E1AFE.7010108@gmail.com> <200707181650.12179.rjw@sisk.pl>
In-Reply-To: <200707181650.12179.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707181652.29045.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 18 July 2007 16:50, Rafael J. Wysocki wrote:
> On Wednesday, 18 July 2007 15:51, Parag Warudkar wrote:
> > 
> > For the first time since 1997 I have a machine (Mac Mini) running a 
> > stock kernel which I am suspending/resuming for 2 days now without any 
> > problems. Amongst the various hardware and kernel versions that I've 
> > used so far this combination is the first to suspend/resume without issues!
> > 
> > But one thing that annoys me a bit is that the load averages spike up 
> > quite a bit after resume although it doesn't feel like the machine is 
> > loaded  -
> > 
> > Before Resume -
> > parag@parag-desktop:~$ uptime
> >  09:35:14 up  5:18,  2 users,  load average: 0.08, 0.87, 1.00
> > After Resume -
> > parag@parag-desktop:~$ uptime
> >  09:36:37 up  5:18,  2 users,  load average: 12.53, 3.83, 1.98
> > parag@parag-desktop:~$
> > 
> > Is this a known problem?
> 
> I think so.
> 
> This probably is due to the freezing of tasks.  Namely, the frozen tasks
> are in TASK_UNINTERRUPTIBLE and add to the load average.
> 
> > Worth fixing? 
> 
> Cartainly.

s/Cartainly/Certainly/
