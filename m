Return-Path: <linux-kernel-owner+w=401wt.eu-S1756431AbZCRGZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431AbZCRGZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 02:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754640AbZCRGZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 02:25:35 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:43828 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758AbZCRGZf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 02:25:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type:content-transfer-encoding;
        b=cnrPb5CQNzHDW0FySymcVTwtfOSEHnZE5AOSGb6T4rZScixyChF/ZdbWa1ANb7WTN5
         BgoIvM5IbWtmO9YCvP3VzGJaTIJFtAJxbZQuWyiio8GcF86vL3AC2o1AxWF5Es9Nz19S
         bl3XUQK+E7T5al+b9hzxj0VZbwy7Pdw8p7+PE=
MIME-Version: 1.0
Date: Wed, 18 Mar 2009 14:25:32 +0800
X-Google-Sender-Auth: 146a82c0d9cf8447
Message-ID: <2a27d3730903172325w16ec329cp872ec35d100f6506@mail.gmail.com>
Subject: nonboot cpu on SMP suspend
From: Li Yang <leoli@freescale.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm curious why we need to un-plug all the nonboot cpus before suspend
and start them all over again after the suspend(ACPI sleep)?  I mean
if we can bring the booting cpu back to the exact state as before
suspend, why can't we just do the same for non-booting cpus?  And that
will be much faster.  Any thought?  Thanks.

- Leo
