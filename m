Return-Path: <linux-kernel-owner+w=401wt.eu-S1756002AbYJEUkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbYJEUkL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 16:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754159AbYJEUj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 16:39:57 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46493 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124AbYJEUj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 16:39:57 -0400
Message-ID: <48E9261A.9060501@firstfloor.org>
Date: Sun, 05 Oct 2008 22:39:54 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.14 (X11/20060911)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: <PING> Re: [patch x86/core] x86: allow number of additional hotplug
 CPUs to be set at compile time
References: <20081001191945.4182d0be@redhat.com> <87bpy3pdgs.fsf@basil.nowhere.org> <20081002152521.16c4835b@redhat.com> <20081002194409.GB8318@one.firstfloor.org> <20081002160907.68d79e0b@redhat.com> <20081002204018.GD8318@one.firstfloor.org> <87ljx4nw09.fsf_-_@basil.nowhere.org> <20081004183014.769836ff@redhat.com> <20081005102835.GA8947@elte.hu> <alpine.LFD.2.00.0810051626150.3398@apollo> <20081005152025.GA27066@elte.hu> <alpine.LFD.2.00.0810051732380.3398@apollo>
In-Reply-To: <alpine.LFD.2.00.0810051732380.3398@apollo>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Please lets get rid of all this.

The result is that there's no way to override a BIOS now that
doesn't declare the number of hotplug CPUs with the Linux hotplug
extension.

Completely trusting the BIOS seems like a bad idea.

So I think you still need the command line parameter back, otherwise there's no
way to override the BIOS.

-Andi (who wished you guys would check with the original author
before removing code you clearly don't understand)

