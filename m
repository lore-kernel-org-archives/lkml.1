Return-Path: <linux-kernel-owner+w=401wt.eu-S1758927AbYAIXiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927AbYAIXiy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 18:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757289AbYAIXb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 18:31:26 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:50414 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756962AbYAIXbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 18:31:24 -0500
Date: Wed, 9 Jan 2008 17:08:53 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Indan Zupancic <indan@nul.nu>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, w@1wt.eu,
       serue@us.ibm.com
Subject: Re: [PATCH][RFC] Simple tamper-proof device filesystem.
Message-ID: <20080109230853.GA26627@sergelap.austin.rr.com>
References: <200801011116.AFH73928.MHFLtOSOOVJFQF@I-love.SAKURA.ne.jp> <200801061520.JEF52626.LFHMtSQJOOVFFO@I-love.SAKURA.ne.jp> <20080106062609.GC20753@1wt.eu> <200801070020.DGI17963.HOOJStVMOFFQLF@I-love.SAKURA.ne.jp> <51953.81.207.0.53.1199738255.squirrel@secure.samage.net> <200801082250.CBI21893.FOQMOtSJFLOHFV@I-love.SAKURA.ne.jp> <45796.81.207.0.53.1199807221.squirrel@secure.samage.net> <200801090439.m094d267092095@www262.sakura.ne.jp> <47176.81.207.0.53.1199887192.squirrel@secure.samage.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47176.81.207.0.53.1199887192.squirrel@secure.samage.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Indan Zupancic (indan@nul.nu):
> Hello,
> 
> On Wed, January 9, 2008 05:39, Tetsuo Handa wrote:
> > Hello.
> >
> > Indan Zupancic wrote:
> >> I think you focus too much on your way of enforcing filename/attributes
> >> pairs.
> > So?
> 
> So that you miss alternatives and don't see the bigger picture.

These emails again are getting really long, but I think the gist of
Indan's suggestion can be concisely summarized:

	"To confine process P3 to /dev/hda2 being 'b 3 2', create
	/dev/p3, launch P3 in a new mounts namespace, mount --bind
	/dev/p3 /dev, exec what you want p3 running, and have
	MAC prevent umount /dev/p3."

This is a neat idea, but Tetsuo's rebutall is

	"P3 may be legacy code needing to create or delete
	/dev/floppy, where -EPERM confuses P3 and prevents
	it working correctly."

Indan's idea is interesting and I like it, but is there an answer to
Tetsuo's problem with it?

thanks,
-serge

PS - Indan, you also said in essence "if P3 can be trusted to create
/dev/floppy why can't it be trusted to create /dev/hda1".  I trust that,
phrased that way, the question answers itself?
