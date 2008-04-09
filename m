Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbYDIG72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbYDIG72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 02:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750996AbYDIG7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 02:59:21 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:27901 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbYDIG7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 02:59:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=NAs83cQusYLa36Lrk/OHtigvkmR8CTrE5zvThywgguSvGv1rmV8z8fsbMMffkyxOr27B8X2MFg7H7evu9DqfIB/7NwBTq+TW1F1JOgoIVmu6gKmIhVnZdN1OyBH+JyXgALLD/e5cV58CrIte7tCYq1CafAnsMYgl5X/biwV+J4U=
Message-ID: <5be025980804082359i125deasfd2e34a3c51f8524@mail.gmail.com>
Date: Wed, 9 Apr 2008 02:59:18 -0400
From: "Wei Hu" <glegoo@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: On what archs are PROT_READ and PROT_EXEC independent?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I know that newer Intel and AMD CPUs support readable and
non-executable pages. But from my tests, if I use mprotect() to set a
page's permission to be PROT_EXEC, that page is still readable. I'm
wondering what architectures implement these flags independently? Is
it possible to get executable and non-readable pages?

Thanks,
Wei
