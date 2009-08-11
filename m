Return-Path: <linux-kernel-owner+w=401wt.eu-S1754855AbZHKObl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbZHKObl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 10:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754821AbZHKObl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 10:31:41 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:63720 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbZHKObk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 10:31:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=t8GtW/33jI0uEZcTmXcPJb+mkjLx7DDDAZNCNzbdg8u96Q8EZobkNr05HBu4hHpe3i
         WiNOUjiz/Zp4NpAmYwwmDEov83TQkR19yX31Ne+jI9qGpFRNPAMUbFZCt/9zPOw/NOVi
         YYP26ll5XGfFEXy0IigreIITK6bCHgt4H1Sw0=
MIME-Version: 1.0
Date: Tue, 11 Aug 2009 20:01:41 +0530
Message-ID: <f74c922b0908110731ifcf162ai8770f07d7ca537d3@mail.gmail.com>
Subject: How to get the address of the page structure from the given virtual 
	address?
From: "B.Vinai Kumar" <vinaibangala2001@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi List

1) I allocated 8 pages using alloc_pages(GFP_KERNEL, 3). This function
returns the pointer to the first page's page structure.
How can I get the page structure address of the remaining 7 pages?

2) There is a function page_address() which takes the page structure
as an argument and returns the virtual address of the page
 that is pointed by that page structure. Is there any method which
retrives the address of the page structure?

Thanks,
Vinai.
