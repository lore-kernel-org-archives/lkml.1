Return-Path: <linux-kernel-owner+w=401wt.eu-S1759191AbZBET1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759191AbZBET1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:27:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbZBET06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:26:58 -0500
Received: from gw.goop.org ([64.81.55.164]:53992 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494AbZBET06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:26:58 -0500
Message-ID: <498B3D80.1010206@goop.org>
Date: Thu, 05 Feb 2009 11:26:56 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: William Lee Irwin III <wli@holomorphy.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: pud_bad vs pud_bad
References: <498B2EBC.60700@goop.org> <20090205184355.GF5661@elte.hu> <498B35F9.601@goop.org> <20090205191017.GF20470@elte.hu>
In-Reply-To: <20090205191017.GF20470@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> But the 32-bit check does the exact same thing but via a single binary 
> operation: it checks whether any bits outside of those bits are zero - just 
> via a simpler test that compiles to more compact code.
>
> So i'd go with the 32-bit version. (unless there are some sign-extension 
> complications i'm missing - but i think we got rid of those already.)

OK, fair enough.  I wouldn't be surprised if gcc does that transform 
anyway, but we may as well be consistent about it.

    J
