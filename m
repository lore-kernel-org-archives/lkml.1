Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903Ab0BPFs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 00:48:27 -0500
Received: from mail-px0-f191.google.com ([209.85.216.191]:44760 "EHLO
	mail-px0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab0BPFs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 00:48:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=UQuFP3m1jTmRwuPY9q5vqsutqIw402mvpsyOQIgnHUStN0ysICRXlNuYo39RdrAkf1
         cdBaFD1M7sDtvCU1PjH2ekykMbLcFVPcoAUNmpph0Av3n+ZF28ZoO4mJTdH29MtbBAY5
         ryBaWPNniSFAP60ZmKQlCLLgOjh42epCO3fH8=
MIME-Version: 1.0
Date: Tue, 16 Feb 2010 11:18:25 +0530
Message-ID: <f22d86811002152148t4f307184kb71757f4621f82db@mail.gmail.com>
Subject: Notification when a task is created/exits
From: "Leonidas ." <leonidas137@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

Is it possible to register a set of callbacks from my module so that
these call backs get called
whenever a certain task is created or exits. Basically, I want to keep
track of all the threads
which are created and are exiting, my module should get notified of
these events somehow.
One way is to call my functions directly from the task creation and
exit functions, but I personally
do not like this approach since I dont want to mess with this core kernel code.

-Leo.
