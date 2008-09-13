Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbYIMHYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbYIMHYU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 03:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753845AbYIMHXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 03:23:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:63654 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbYIMHXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 03:23:47 -0400
Date: 13 Sep 2008 09:09:00 +0200
From: lirc@bartelmus.de (Christoph Bartelmus)
To: jwilson@redhat.com
Cc: j@jannau.net
Cc: linux-kernel@vger.kernel.org
Cc: stefan.bauer@cs.tu-chemnitz.de
Message-ID: <AlnDyrZJjFB@christoph>
In-Reply-To: <200809121224.34345.jwilson@redhat.com>
Subject: Re: [PATCH 02/18] lirc serial port receiver/transmitter device driver
User-Agent: OpenXP/4.10.7369 (Linux) (i386)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1+PludQLm8PtH9V/IFoDnjUv+eVDXrfRuJYKF/
 G4VSob51WK/swnrmkozwHc1nZstZC/4XxE9mRzq8lqvKLPetNH
 cyxPDiZ6YNdaYbqApiBmldIRzkzUZEkIgCgTY/MI2s=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jarod,

on 12 Sep 08 at 12:24, Jarod Wilson wrote:
> On Thursday 11 September 2008 15:49:25 Stefan Bauer wrote:
>> Jarod Wilson wrote:
>>>> Nothing in this function does anything to assure itself that the port
>>>> actually exists and is the right kind of hardware.  Maybe that can't
>>>> really be done with this kind of device?
>>>
>>> We should probably try to make sure the port actually exists, but I don't
>>> think there's a whole lot (if anything) we can do as far as verifying the
>>> device itself.

> I've borrowed the simple existence test from
> drivers/serial/8250.c::autoconfig(), which tries a few reads and writes from
> UART_IER. I think this is probably sufficient for verifying the port is
> legit.
>
> Christoph B., you're definitely much more familiar with serial IR devices
> than I am... Is there any sort of test you can think of that we could use to
> try to verify the existence of an IR device hooked to the port? Or should we
> be happy we at least know there's a port and just assume the IR device is
> there?

No, I can't think of anything else. OTOH there have never been real  
problems with this for the past 10 years...

Christoph
