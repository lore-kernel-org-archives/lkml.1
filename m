Return-Path: <linux-kernel-owner+w=401wt.eu-S1751236AbZG3MpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751236AbZG3MpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 08:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbZG3MpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 08:45:08 -0400
Received: from mail-px0-f203.google.com ([209.85.216.203]:55245 "EHLO
	mail-px0-f203.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbZG3MpH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 08:45:07 -0400
X-Greylist: delayed 1483 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Jul 2009 08:45:07 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=C/tDGbdyFxcc0CYi5FBQFzoFFAxsW8ShZsmWN3Dco9dOfv4gI9+gq89UccjCBM+ql6
         zZTcf/tE9B4+ryO2EpSanZmXTrm/3PSK0N9XBgJxfzwGC07gNXl7jUeKs6BOw25HG4Mp
         DwPmV+MCLlnn5XQUO23RCc+DOEvQTbP3x2fm0=
MIME-Version: 1.0
Date: Thu, 30 Jul 2009 15:20:24 +0300
Message-ID: <b90c0690907300520t1dfbd722j73417b1beb6992bc@mail.gmail.com>
Subject: regulator: adding enable control to fixed regulator interface
From: Roger Quadros <quadros.roger@gmail.com>
To: broonie@opensource.wolfsonmicro.com
Cc: lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Mark,

I have the following use-case scenario for a fixed voltage regulator.


Supply ----->| Regulator |-------> Peripheral

                  ^ EN
                  |
GPIO -------------


The regulator's enable pin is controlled by a GPIO of the CPU.

What is the best way to implement this within the regulator framework?
Writing a regulator driver is one solution but I'm sure there must be
many instances like this and writing a driver for each case is not
that nice.

I want to use the fixed regulator driver but this does not have
regulator enable/disable control.

Isn't it a good idea to have enable/disable control for the current
implementation of the fixed voltage regulator i.e. drivers/regulator/fixed.c ?

The regulator enabling/disabling functionality can be implemented by
platform code and the required function pointers could be passed through
fixed_voltage_config structure.

If this looks OK, I can send you a patch to implement this functionality.

cheers,
-roger
