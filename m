Return-Path: <linux-kernel-owner+w=401wt.eu-S1757052AbZEOLF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052AbZEOLF7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 07:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753412AbZEOLFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 07:05:49 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:62505 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbZEOLFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 07:05:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=aIcjZ+Xl5BU4Vuc80Yhxi04c4xdDd5+Vg1deRtrAvV2pGTaFpXKZQXRrrh820fM2RH
         tqPDQzTC2UR5h8rzuvPfHtC/50Ke9ShR9eeBs3g9+MBW8ZsdE7A+CK0wUOyv98v75xq4
         Cl/goRDw4J8hvTTH26BQXM9oVvynAFC6fWdVk=
MIME-Version: 1.0
Date: Fri, 15 May 2009 16:35:49 +0530
Message-ID: <de72ca4e0905150405w495a359ei7c4a625ff82edb11@mail.gmail.com>
Subject: patch related to SIGSEGV handling in multiple threads and hung 
	threads
From: Sudarshan Soma <sudarshan12s@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi ,
I have a program which will create multiple threads. One of the thread
receives SIGSEGV and it prints stacktrace in its handler and calls
_exit(-1). The call to exit wont terminate all threads in  a process
and hence thread hangs here. This causes resouce leaks and other
problems. It is seen only on linux 2.4.20.

For printing stacktrace it uses
__builtin_return_address and __builtin_frame_address


The same program works fine on linux 2.6.26 kernel. It  will exit the
whole process when one of its thread dies as above.


Please let me know the patch details or any workaround, if any. This
is a bit urgent, so please let me know for any pointers , if any

Thanks and Best Regards,
Pavan.
