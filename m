Return-Path: <linux-kernel-owner+w=401wt.eu-S965337AbXDMUv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965337AbXDMUv3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 16:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030278AbXDMUv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 16:51:29 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:9833 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965337AbXDMUv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 16:51:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=J+Vei5i+Zg23AGyDWS9JraQFJwXuCudfQIHk9/gs3e+AkYALSbstjtTGd9BDlStRM0FCWZNUQ9e1YLib1aSyA/dEJMUuqhJ3rrbYnHopR8162TNE5F65FFsZyXYAid1whSGBOsUSX2gpGx6A+OlRyyj9V1uzos+DGT8p53r+kIM=
Message-ID: <38b2ab8a0704131351la5085vf0ab58e85cf49879@mail.gmail.com>
Date: Fri, 13 Apr 2007 22:51:27 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: dbrownell@users.sourceforge.net
Subject: question on generic gpio interface
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to port my old gpio code to the generic one to see if it
can fit my needs.

The gpio controller is a home made one and has a really weird
interface. It has several registers to read the gpio status, to
configure gpio directions, or to configure if a gpio can trigger an
interrupt and on which event (level or edge). All gpios use the same
IRQ and a gpio controller register allows to read which gpio has
triggered the interrupt.

Now the question is how should irq_to_gpio()  work ? Is it supposed to
be called only when a gpio interrupt occure ?

Another question is how can I specify if a gpio interrupt trigger on
level or on edge ?

thanks
-- 
Francis
