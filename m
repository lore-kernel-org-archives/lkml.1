Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab0B1W6N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 17:58:13 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:38476 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881Ab0B1W6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 17:58:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type;
        b=Hs0syOmuvE9Twds0GqjiEqr9aLvznuTIbKMDZ99LWEabqGgHH5U/3WthX/kiNk+NIc
         D2M1352sMu8+T3MQZJN9Sr6sxyErBjBxLlVfL1IPfaJIRaOkyFVyY6V2wQKrRq7nVRVF
         qJimaxlj76Fyy4VG0dOo4JW4h38BLOd/kdhp0=
MIME-Version: 1.0
Date: Sun, 28 Feb 2010 23:58:10 +0100
X-Google-Sender-Auth: 597eeca9a45b35d5
Message-ID: <9c30dffe1002281458w5705378fj52f36c5d352593fb@mail.gmail.com>
Subject: Problem with bridges and wireless NIC's
From: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

There is a problem when trying to create a bridge containing a normal
NIC and a wireless NIC, and using hostapd.

The problem is, that it is not possible to create a bridge containing
a wireless NIC, if it hasn't been setup first.

Does anyone have a solution for this?

(The commit that introduced this problem is
ad4bb6f8883a13bb0f65b194dae36c62a02ac779 , reverting it solves the
problem).

For more info, please have a look at this bug report:
http://bugs.gentoo.org/show_bug.cgi?id=298824

Best regards,
Bjarke I. Pedersen
