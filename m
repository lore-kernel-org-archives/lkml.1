Return-Path: <linux-kernel-owner+w=401wt.eu-S1752659AbYIBKiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbYIBKiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 06:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbYIBKhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 06:37:52 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:20962 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbYIBKhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 06:37:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=N2TMpjKp9Is6QEIOIuhhddjXtzpELLHx8uRcyk+Vw+RJyLmJCFpauwGWxFI/mLzNDD
         Z8IgB0n+yeJ4+Rm8l1NMjKy7y67tj6+HHbb70lJPOlFI05FHSczraHfVAezP+WWx1o0U
         k1Ta0agtIPb9YfYPGp4JDTFaqWEOkiTzeyE1o=
Message-ID: <48BD1779.5030807@gmail.com>
Date: Tue, 02 Sep 2008 13:37:45 +0300
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Please #include <limits.h> in hackbench.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Fedora Core 9 hackbench.c fails to compile because PTHREAD_STACK_MIN
is not defined, adding
a #include <limits.h> fixes it and makes it compile.

Please add #include<limits.h>

Best regards,
--Edwin
