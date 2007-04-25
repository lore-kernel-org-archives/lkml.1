Return-Path: <linux-kernel-owner+w=401wt.eu-S2992551AbXDYKFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992551AbXDYKFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 06:05:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992561AbXDYKFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 06:05:10 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:52729 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992551AbXDYKFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 06:05:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=rhEsz7vc13d9doVELnrGo/6HS6BUbEt1Afa7dwT3xbrUn6lP9je3fLteq9fTqf4Cg9NqCsDBVnJo1qmvE6lf8AHASy4EZS4TVeGNsbPzVtQcz5uR0f3AcZX8lSe4hS6E9exg2dkJv/2OeI3/Bq8Lfew03IBbCM4ZIkB6rps6bdo=
Message-ID: <8bd0f97a0704250305qe6175cdm8e1a0cd7844f67bc@mail.gmail.com>
Date: Wed, 25 Apr 2007 06:05:06 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: dbrownell@users.sourceforge.net
Subject: adding bits_per_word to struct spi_board_info to mirror struct spi_device
Cc: spi-devel-general@lists.sourceforge.net,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Wu, Bryan" <Bryan.Wu@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

the spi_device structure has a bits_per_word so that you can change
the value on a per-device setting, yet the spi_board_info structure
does not ... this means that the bus-specific structure has to have a
bits_per_word member which the spi bus driver will copy into the spi
device bits_per_word member

is there something obvious i'm missing ?  seems to me that if the
generic spi framework respects bits_per_word on a per-spi device
basis, then it should be exposed in the generic info structure so that
the setting can be tracked in the boards file ...
-mike
