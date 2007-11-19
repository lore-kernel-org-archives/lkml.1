Return-Path: <linux-kernel-owner+w=401wt.eu-S1753111AbXKSKm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbXKSKm0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 05:42:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbXKSKmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 05:42:19 -0500
Received: from web52901.mail.re2.yahoo.com ([206.190.49.11]:26830 "HELO
	web52901.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750784AbXKSKmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 05:42:18 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=veZAN8MlVvNkqSxLHl09wrV2T9Pl4xZIsaWinVlN6NV1EJX8SSRD/rOWFkjZ1u/X1JPVmo7Z3G7AuX5P6YLveGHfWba6JPLo6WZ7bvkWmnfTT/2FKS4q1HEV8iyL2XMm6Pm6+zc+XF8tMCLDoZGTz7b2k9UPKqQHg+NA8fNZRy0=;
X-YMail-OSG: HHpKJJwVM1k5TFLu69t5Gs5QfbX2wZ7z_6YtYtIgj6gjimMWfx4JRBYLGbO2wS1ySAduQ1l93hp9shsIICRvoxpkvaZ5LMN63.J9PozBCQoE2A9aUIvQIYbtKNop_rw9FiATN4p43NCCx.nF24iOUWbLAA--
Date: Mon, 19 Nov 2007 10:42:16 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: Kernel oops with udevd process
To: Raman Gupta <raman@rocketraman.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <47412C14.9080002@rocketraman.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <808128.70645.qm@web52901.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- Raman Gupta <raman@rocketraman.com> wrote:
> I just found this bug:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=8198
> 
> This seems to indicate the problem was resolved in 2.6.21.2.
> 
> However, I also found this, where you reported the problem was back in 
> 2.6.22.9 (which is what I am currently running):
> 
> http://lkml.org/lkml/2007/10/9/190
> 
> As I said before, I am not a kernel hacker but if I can assist in some 
> way I'd be happy to.

Raman,

The original bug #8198 was resolved, but that doesn't mean that a new bug can't appear with the
same symptom. I was unable to reproduce the bug in the 2.6.22.9 kernel, but if you can then I
would alert Tejun Heo or Greg Kroah-Hartman. (Tejun said that he thought my second bug looked like
a module-reference counting problem.)

Cheers,
Chris


      ___________________________________________________________ 
Want ideas for reducing your carbon footprint? Visit Yahoo! For Good  http://uk.promotions.yahoo.com/forgood/environment.html
