Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbYFSVzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbYFSVzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 17:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbYFSVy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 17:54:56 -0400
Received: from gw.goop.org ([64.81.55.164]:57642 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbYFSVyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 17:54:55 -0400
Message-ID: <485AD584.1040908@goop.org>
Date: Thu, 19 Jun 2008 14:54:12 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu
 area
References: <20080604003018.538497000@polaris-admin.engr.sgi.com> <20080604003019.509483000@polaris-admin.engr.sgi.com> <20080605102222.GA21319@elte.hu> <484EF29C.7080100@sgi.com> <485947A8.8060801@goop.org> <4859511E.5050605@sgi.com> <48596315.6020104@goop.org> <48596893.4040908@sgi.com> <485AADAC.3070301@sgi.com> <485AB78B.5090904@goop.org> <485AC120.6010202@sgi.com> <485AC5D4.6040302@goop.org> <485ACA8F.10006@sgi.com> <485ACD92.8050109@sgi.com> <485AD138.4010404@goop.org>
In-Reply-To: <485AD138.4010404@goop.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 64-bit inherits 32-bit's use of per-cpu gdts, though its mostly 
> useless on 64-bit.

Note to self: Not really true; they're still needed for 32-on-64.

    J
