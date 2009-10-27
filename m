Return-Path: <linux-kernel-owner+w=401wt.eu-S1753113AbZJ0OTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbZJ0OTL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 10:19:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbZJ0OTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 10:19:10 -0400
Received: from mail-px0-f180.google.com ([209.85.216.180]:58939 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbZJ0OTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 10:19:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=VuFlq6wQs+DSr/kAZJdVjZJQEGPqoRlYRXLouV8jha97rF9YAgiCmyUxzliDBig9Az
         rc5G3hQ7Fsny+Ms0V/SARct/pv2zd1cxkZpI2ga+Hre93/rklAkj/RR1qaPVnWG8pB3Y
         xQ8RRZhlfEsV2+CWumajzZyND+h3o0tIvcncU=
MIME-Version: 1.0
Date: Tue, 27 Oct 2009 22:19:14 +0800
Message-ID: <2674af740910270719u2b097eb5n6a4a5019d5646f0a@mail.gmail.com>
Subject: _RET_IP_ VS __builtin_return_address(0)
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With a grep search, I find the usage of _RET_IP_ and __builtin_return_address(0)
in current kernel:
_RET_IP_           __builtin_return_address(0)
     89                                128
Actually this isn't matter with the runtime behavior.
But I'm wondering if there is any trend to unify this kind of usage?

Thanks,
Yong
