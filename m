Return-Path: <linux-kernel-owner+w=401wt.eu-S1755130AbYG2G7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130AbYG2G7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 02:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384AbYG2G7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 02:59:22 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:35822 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbYG2G7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 02:59:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=eVli0HZVy79wxEQI0YbJFuxvonf8OGMh978uCU6aynCDZJmOuMNIKRMjlDNm61K4db
         nm5cZ/23XjkBltJwRQ62LgCk2cZIdCjpNaCV65/59RdPwjKYTsWKP7yrm624jYh9xCEd
         SCDQ379sofyCaK33tnkSGpIZ9osfxDpxobPD0=
Date: Tue, 29 Jul 2008 10:59:14 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: davem@davemloft.net, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: sparc64: build failure at sys_sparc32.c
Message-ID: <20080729065914.GA30878@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I am testing build using randconfig.

arch/sparc64/kernel/sys_sparc32.c: In function 'sys32_chown16':
arch/sparc64/kernel/sys_sparc32.c:63: error: implicit declaration of
function 'low2highuid'
arch/sparc64/kernel/sys_sparc32.c:63: error: implicit declaration of
function 'low2highgid'
arch/sparc64/kernel/sys_sparc32.c: In function 'sys32_getresuid16':
arch/sparc64/kernel/sys_sparc32.c:106: error: implicit declaration of
function 'high2lowuid'
arch/sparc64/kernel/sys_sparc32.c: In function 'sys32_getresgid16':
arch/sparc64/kernel/sys_sparc32.c:123: error: implicit declaration of
function 'high2lowgid'

These functions are defined in linux/highuid.h only if CONFIG_UID16 is enabled.
