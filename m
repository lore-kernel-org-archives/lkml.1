Return-Path: <linux-kernel-owner+w=401wt.eu-S1753467AbYGVWwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbYGVWwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 18:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754866AbYGVWwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 18:52:39 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:46196 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbYGVWwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 18:52:38 -0400
Date: Wed, 23 Jul 2008 00:52:36 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Kevin Holland <khollan@daktronics.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: map keyboard to stdin
In-Reply-To: <1216760127.6242.18.camel@kevin-laptop>
Message-ID: <alpine.LNX.1.10.0807230050450.23410@fbirervta.pbzchgretzou.qr>
References: <1216760127.6242.18.camel@kevin-laptop>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 2008-07-22 22:55, Kevin Holland wrote:

>Hi all,
>I have an embedded Linux board that uses 2.6.21, the console is output
>the serial port.  How can I set it up so a USB keyboard will be accepted
>as input as well as anything received from the serial port and it will
>be echoed to the output of the serial port as well.  Basically I want to
>issue commands either through a terminal program to the embedded board
>or a USB keyboard that is connected to the board, but I still want to
>see what was typed on the keyboard out the serial terminal. I have
>enabled USB HID support in the Kernel as well.

Try booting with  console=tty0 console=ttyS0
I am not sure whether this will accept input from both (that's for you 
to test), though it definitely outputs to both.
