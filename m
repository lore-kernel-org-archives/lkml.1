Return-Path: <linux-kernel-owner+w=401wt.eu-S1764044AbYHFFpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764044AbYHFFpT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 01:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755128AbYHFFot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 01:44:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:50791 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbYHFFos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 01:44:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=JIOcg5Rcxu06MNB2sSt+qKLTf6ww9Np6m6P0tNT6E4SqvSlxjlMtQLuKe837Oi8fHB
         f6B5Q2tDKZV5kfxS3ScPPA1J9R7PzXXx9cYBTtE4PszRwyBXqSM3BAB12a7pOe0s5BCg
         PyQ8J2caH5GfHE2TGARZUjSTq24bm+aloEaAk=
Message-ID: <cd029cbb0808052244w5c76625pc7f51aaa36eac9e9@mail.gmail.com>
Date: Tue, 5 Aug 2008 22:44:46 -0700
From: "Alto Tom" <alto.tom@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Driver rtl8185 Realtek pci wireless card
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Problem found in the following kernels
2.6.26,2.6.25

Distribution slackware 12.1 and 12.0

Compile the module rtl8185 (realtek wireless PCI card) module  name r8180
OS hang during boot during UDEV configuration need to turn off computer.

kernel 2.6.25
Compile the driver inside the kernel, boot is OK as long as I do not
try to configure  the network.
I was able to ifconfig wlan0 up but the system hang during DHCP, no
oops just hang. Need to turn off
the computer.

I believe to be a problem related to IRQ sharing.
Alfredo
