Return-Path: <linux-kernel-owner+w=401wt.eu-S1761575AbYDUPvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761575AbYDUPvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 11:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754325AbYDUPvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 11:51:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:25861 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119AbYDUPvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 11:51:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lx4F+vFyFJ0q/BNytA8SMlwHz/VWPIm5RWWscuovqcZ83DrxYg233ChE01f7mEtoM3WnwomuBuxZ83vmJgnb/xlNY6R1Po0ZbyETJLFAp62OcRFiyL+9Amz7mvDkAGDzQ6j1h2E6oPpFNXvBPz+N45NbxXvlScZpoL5wsRnvbd8=
Message-ID: <e2e108260804210851j5cd86901r37f65190fac8a024@mail.gmail.com>
Date: Mon, 21 Apr 2008 17:51:01 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Frantisek Rysanek" <Frantisek.Rysanek@post.cz>
Subject: Re: What pokes the ISA IO port of 0x211 ?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <480C92C9.18283.A24BB91B@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <480C92C9.18283.A24BB91B@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 1:12 PM, Frantisek Rysanek
<Frantisek.Rysanek@post.cz> wrote:
>  I'm dealing with an embedded PC motherboard that contains some custom
>  circuitry (GPIO), accessible via an ISA IO range between 0x200 and
>  0x218.
>
>  There's an interesting issue with this in recent Linux (tried
>  2.6.22.6 and 2.6.24.2): something probes IO port 0x211 on boot, which
>  happens to be an add-on buzzer control port - effectively the kernel
>  boot launches an accoustic alarm :-)
>
>  Any ideas what this could be?

Did you already have a look at /proc/ioports ? This file should
contain every range of ISA bus address in use by any kernel component.

Bart.
