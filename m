Return-Path: <linux-kernel-owner+w=401wt.eu-S1755286AbXIQOHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbXIQOHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 10:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbXIQOG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 10:06:58 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:54897 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbXIQOG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 10:06:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=CDF4R/sHQZ7++GzWBFLqMuxwPVj0DP5oQ6MbEOum2ZzK5iZePZf0RJZJvT7V0GLjger8dff/reRANTmsMXDjaXAX6KBVpp5wz6zP9UIi1EVENhGRJy8NIKisfjMWd4dQAUcA12ghC4SRXy23OvFzudoZKBCMFp7CpY2l9HdnQl4=
Message-ID: <8bf247760709170706j6025bb14k8ab28f9467972c76@mail.gmail.com>
Date: Mon, 17 Sep 2007 19:36:56 +0530
From: Ram <vshrirama@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Floating point computations in kernel modules
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

   I am trying to write a driver which uses double, float. I am using
an arm11 with gcc 3.4.4

   When i try to compile my modules (with float variables) i get the error

   WARNING: "__extendsfdf2" undefined!
   WARNING: "__mulsf3"undefined!
   WARNING: "__fixsfsi"undefined!
   WARNING: "__floatsisf"undefined!

   Can we use float, double in kernel modules?.

  Obviously it is a linking error, I am using soft-float. I tried with
-msoft-float but got the same   result.

  I suspect that its a toolchain issue.  However i am able to compile
my applications
  with float, double variables.


  Please do advice.


Regards,
sriram
