Return-Path: <linux-kernel-owner+w=401wt.eu-S1751184AbYCEFEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751184AbYCEFEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 00:04:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750828AbYCEFEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 00:04:13 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:38699 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756616AbYCEFEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 00:04:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=c+ZkX+7hWIVqLcuOjJy333Q2OPK3C81zA0FZm0uaEWdQzCIPhOzl+VESAZt0UNHJXsN0wBNll6C2llzxnZaU8lGoN26FKGRvXZtxiOn4UT73K+qmdVTNUKYsVC5CaKRqa9KxfqyGASyjdHI+YFtBIhjO22jZI6VkVbFa7H/UUDA=
Message-ID: <86802c440803042104p77f44d5fnd4aeb86e21ec8c66@mail.gmail.com>
Date: Tue, 4 Mar 2008 21:04:09 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Greg KH" <gregkh@suse.de>
Subject: x86_64: set cfg_size for AMD Family 10h in case MMCONFIG should be material for 2.6.25
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo/greg,

one patch in x86.git#testing

    x86_64: set cfg_size for AMD Family 10h in case MMCONFIG

    reuse pci_cfg_space_size but skip check pci express and pci-x CAP ID.

should be get into 2.6.25. instead of waiting for 2.6.26

it just one quirk to update AMD fam10h cfg_size if MMCONFIG is there.

otherwise lspci -vvxxxx still report 512 for those NB.

YH
