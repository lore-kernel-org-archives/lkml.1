Return-Path: <linux-kernel-owner+w=401wt.eu-S1759825AbYFGGWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759825AbYFGGWH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 02:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbYFGGV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 02:21:56 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:61075 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbYFGGVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 02:21:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=EToYpmOJtPV6JZ7XtBXfg7Uei6H/+ua73OK3UgD1+qbuHSiuAkbC85RG5x//9WI1oN
         FjBO5itLpMB85gvFmINjokIppysfE+P3rk4RMg1z86sqCCPx2eMj865MnRrTP8HMx105
         23WLbzQ2z8hYHFVHeXeLO56XuyXk9XV7ZWASA=
Message-ID: <dd18b0c30806062321x2918f6feq7c817bde52ba0c4c@mail.gmail.com>
Date: Sat, 7 Jun 2008 06:21:54 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: bugme-daemon@bugzilla.kernel.org
Subject: ACPI: EC: GPE storm detected, disabling EC GPE
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well; I was hoping it was going to be just an easy fix, but unfortunately
changing
 if (atomic_read(&ec->irq_count) > 5) {
 to
if (atomic_read(&ec->irq_count) > 20) {
does seem to make the message disappear, for a while, probably at
around three hours,(for me at least) then the message appeared again.
:-(
So leaving me back to the beginning of try to have a go at this.
regards;
-- 
Justin P. Mattock
