Return-Path: <linux-kernel-owner+w=401wt.eu-S1751367AbXBRQEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751367AbXBRQEX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 11:04:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbXBRQEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 11:04:22 -0500
Received: from an-out-0708.google.com ([209.85.132.249]:19187 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbXBRQEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 11:04:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=S5vHUfp6U+ePJTkHZGvqiZ7HXmTwc5dNtr9wr4g4swp9tB+yXNYJglgRq3xx0JABB4mylj/KX345OTA/SYSzHuqIVtvy6WoXWPVJoNTTNgDI74ZiHrhGcwTD7+rfWKCRKcwGpqOarCspK+Li46gY2Go2biGHzeT2FregY+1S570=
Message-ID: <38b2ab8a0702180804l26d99a01y558bce2ee964d973@mail.gmail.com>
Date: Sun, 18 Feb 2007 17:04:19 +0100
From: "Francis Moreau" <francis.moro@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: memparse(), simple_strtoul() prototypes...
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I must miss something...

Looking at these prototypes

unsigned long simple_strtoul(const char *cp, char **endp,unsigned int base)
unsigned long long memparse (char *ptr, char **retptr)

I'm really wondering why not all parameters are not all 'const'. None
of these functions modify any pointer containts. And simple_strtoul()
ends up doing sometghing like:

if (endp)
		*endp = (char *)cp;

Could anyone shed some light ?
-- 
Francis
