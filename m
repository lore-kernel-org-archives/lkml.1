Return-Path: <linux-kernel-owner+w=401wt.eu-S1755645AbZF0N6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645AbZF0N6A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 09:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbZF0N5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 09:57:51 -0400
Received: from mail.anarazel.de ([217.115.131.40]:56925 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbZF0N5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 09:57:51 -0400
Message-ID: <4A46255E.8090104@anarazel.de>
Date: Sat, 27 Jun 2009 15:57:50 +0200
From: Andres Freund <andres@anarazel.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090625 Shredder/3.0b3pre
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>
CC: LKML <linux-kernel@vger.kernel.org>, Eric Anholt <eric@anholt.net>,
       Dave Airlie <airlied@redhat.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Renninger <trenn@suse.de>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Len Brown <len.brown@intel.com>
Subject: Re: [BUG] GM45 blanks shortly after boot in 2.6.30-git
References: <4A43359F.3030208@anarazel.de> <4A459D85.2080008@anarazel.de> <20090627044325.GA5086@ldl.fc.hp.com>
In-Reply-To: <20090627044325.GA5086@ldl.fc.hp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2009 06:43 AM, Alex Chiang wrote:
> * Andres Freund<andres@anarazel.de>:
>> I have not yet had access to another computer (so no trace yet) but I
>> bisected it to this very innocent looking commit:
>> 1e4cffe78e1decd937c7b78410eec87da6b87954 : ACPI: video: convert to
>> acpi_get_pci_dev
>
> This has already been fixed in Linus's tree. Can you pull the
> latest and try again?
Works as expected. Thanks.


Andres
