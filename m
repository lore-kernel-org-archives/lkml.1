Return-Path: <linux-kernel-owner+w=401wt.eu-S934151AbZJITmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934151AbZJITmJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 15:42:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753734AbZJITmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 15:42:08 -0400
Received: from mail-yx0-f187.google.com ([209.85.210.187]:42050 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbZJITmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 15:42:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=aBG2NcBdUmF/KP9XfJo87rNdWtiQGXq80i9SXWcuzJ2yaXFhOZ9OiEmwFhOpD9uwxg
         GIGM+HmB4NquxdIUbXpY8lype3VH550Z6fVRBnGhKmFJ9U1wejnC2D3jxGW4AAd5R/cW
         PIwJwRnmxHqgYUSoouS/VAoQYHm0s/esCD3bU=
MIME-Version: 1.0
Date: Fri, 9 Oct 2009 21:41:30 +0200
Message-ID: <71cd59b00910091241m115ee71cl54b76173dac1d74f@mail.gmail.com>
Subject: Adding a special key for touchpad toggle
From: Corentin Chary <corentin.chary@gmail.com>
To: linux-input@vger.kernel.org, linux acpi <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
in drivers/platform/x86/ there is 3 drivers who need a key to toggle
the touchpad:
- topstar-laptop.c: mapped to KEY_F13
- asus-laptop.c: mapped to BTN_TOUCH, don't know why
- eeepc-laptop.c: I didn't do the patch yet, because I don't know what
key to use

Do you think we need a new key ? (KEY_TOUCHPAD)
Should we use KEY_F13 in all drivers ?
Thanks,
-- 
Corentin Chary
http://xf.iksaif.net
