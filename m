Return-Path: <linux-kernel-owner+w=401wt.eu-S1756755AbZDGNAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbZDGNAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 09:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756623AbZDGNAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 09:00:14 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:49525 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756416AbZDGNAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 09:00:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=sgVBoQjDoHonNsL+Xlub4qN1n+H6tnx82+zlRI/Od2rxzesPsRreibZZeNR8Cr1Hjy
         uSYef4dC4z+mmSgxTbB1YKr7hqDC4k+GhHnY9bx7q/1WyQ4+JKF1ukjZ1ZcNGnzzscsq
         iwKJTtslIVlE5ye/VMg8TlbR0d9hTKUu4IwAA=
Subject: Re: 2.6.29+ ath5k connect disconnect cycles?
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Soeren Sonnenburg <sonne@debian.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1239008128.32048.211.camel@localhost>
References: <1239008128.32048.211.camel@localhost>
Content-Type: text/plain
Date: Tue, 07 Apr 2009 16:00:08 +0300
Message-Id: <1239109208.15015.11.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-06 at 10:55 +0200, Soeren Sonnenburg wrote:
> Dear all,
> 
> does anyone else observer strange connect disconnect cycles with ath5k?
> I have two different notebooks here one with an AR5414 and one with some
> 2424 (?) chipset both having the same problems to connect...
> 
> Soeren

I use latest -git of wireless-testing, and AR2425.
Thanks to hard work of ath5k developers, it works better and better.
Yet phy seems to die when loaded with traffic, but its reset brings is
back alive. ath5k does a reset every 10 seconds.

If you use WPA, then you might have bigger problems, I mean, during the
period when phy is dead, AP might ask for group rekey, but ath5k won't
hear this, and continue using old keys. This causes much longer delays,
and sometimes reconnect cycles you see.

Best regards,
	Maxim Levitsky

