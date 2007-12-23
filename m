Return-Path: <linux-kernel-owner+w=401wt.eu-S1755681AbXLWQ40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681AbXLWQ40 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 11:56:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbXLWQ4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 11:56:18 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:10400 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbXLWQ4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 11:56:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=m7ftNolUKtXL+knVphfXgfGlhfTyLPaZBBUFqJrDog73G228wah2wMfr97/nokLzXFx6nb7/ar80uItaHzVZ7iuXaIa+PEvAkFC4c6RseO6YJ5yIWGuyFnyeXW3jjDoSZDdDLn2c+aQuHV2cHcOdFY8jQjPAN6VfqeyYKobwb94=
Message-ID: <8b67d60712230856o73bc89d7u142b93fc47b7533b@mail.gmail.com>
Date: Sun, 23 Dec 2007 16:56:14 +0000
From: "Adrian McMenamin" <lkmladrian@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Correct use of __init and __devinit
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could someone here help settle this argument?

I have written a driver (for the CD Rom on the Sega Dreamcast). I have
marked various initialisation functions - including probe() and the
functions that it, and only it, calls, as __init.

Other developers tell me I should mark them as __devinit.

However I think this is wrong as:

* The CD on the Dreamcast is not and will never be a hotpluggable device

* The Dreamcast is a limited memory device and if marking various
functions as __init helps save memory that is A Good Thing

It has been put to me that while the use case (not hotpluggable) is
correct, it is still better practice to use __devinit

I have built the code with both __init and __devinit and both work, so
there is no issue of practicality as such here.

Adrian
