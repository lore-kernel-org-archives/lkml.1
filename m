Return-Path: <linux-kernel-owner+w=401wt.eu-S933585AbYFTUsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933585AbYFTUsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765585AbYFTUhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:37:07 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33601 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757256AbYFTUhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:37:06 -0400
Date: Fri, 20 Jun 2008 13:37:04 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mike Travis <travis@sgi.com>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu
 area
In-Reply-To: <485C0D48.3090008@sgi.com>
Message-ID: <Pine.LNX.4.64.0806201336400.16501@schroedinger.engr.sgi.com>
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>
 <484EF29C.7080100@sgi.com> <485947A8.8060801@goop.org> <4859511E.5050605@sgi.com>
 <48596315.6020104@goop.org> <48596893.4040908@sgi.com> <485AADAC.3070301@sgi.com>
 <485AB78B.5090904@goop.org> <485AC120.6010202@sgi.com> <485AC5D4.6040302@goop.org>
 <485ACA8F.10006@sgi.com> <485ACD92.8050109@sgi.com> <485AD138.4010404@goop.org>
 <485ADA12.5010505@sgi.com> <485ADC73.60009@goop.org> <485BDB04.4090709@sgi.com>
 <485BE80E.10209@goop.org> <Pine.LNX.4.64.0806201045460.15874@schroedinger.engr.sgi.com>
 <485BF8F5.6010802@goop.org> <Pine.LNX.4.64.0806201148430.16227@schroedinger.engr.sgi.com>
 <485BFF57.5090906@goop.org> <m1hcbnq4dw.fsf@frodo.ebiederm.org>
 <485C0D48.3090008@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2008, Mike Travis wrote:

> > Is this a change that only got tested on x86_32?
> 
> I'm only testing this on x86_64.  The zero-based percpu/pda changes worked fine
> up until just recently.  At first it was one of Ingo's "randconfig" config files
> that was tripping it up, but lately it's not working on any config.

x86_32 does not need the zero basing since it does not have a pda.
