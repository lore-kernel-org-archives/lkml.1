Return-Path: <linux-kernel-owner+w=401wt.eu-S1752464AbZGTQjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464AbZGTQjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 12:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751219AbZGTQjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 12:39:23 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:14031 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbZGTQjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 12:39:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=CrgG5SREnYI9kEQrQqz4ecc1dykj6+TgXU8ko61PBIvxG3ImI0QFKpKkANCdw6IwgU
         xNhD+zyQEOefLPglwFtak5iP73nUAP8T8jyeDzxh4GLOTRia7nXHAhxQrrqz5eu8fv1M
         4lXi+MHKvGONwuEvGysdFtY9gNlFvKPHUqIPU=
MIME-Version: 1.0
Date: Mon, 20 Jul 2009 13:39:21 -0300
Message-ID: <6de6b1650907200939t471bbb49m5d10f343267faee2@mail.gmail.com>
Subject: using ioctl to change the interface's IP
From: Rafael Almeida <almeidaraf@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I was studying ioctl recently and I found out that, in order to change
the IP of a certain interface, you have to create a dummy socket with
socket(2) and use the returned file descriptor in the ioctl call. That
seems strange to me because the IP is not changed only for that
particular descriptor, but globally. Why wasn't a new system call
created for handling situations such as that?

[]'s
Rafael
