Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbXDTI2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbXDTI2z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 04:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754130AbXDTI2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 04:28:55 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:53061 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754139AbXDTI2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 04:28:53 -0400
Message-ID: <462879BE.1050401@gmail.com>
Date: Fri, 20 Apr 2007 10:28:46 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>
Subject: const struct pci_driver [Was: [RFC 2/2] Input: phantom, add a new
 driver]
References: <210731960111436322@karneval.cz>	<258431179037841809@karneval.cz> <20070419230719.a118a132.akpm@linux-foundation.org>
In-Reply-To: <20070419230719.a118a132.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napsal(a):
> On Tue, 17 Apr 2007 22:02:10 +0200 (CEST) Jiri Slaby <jirislaby@gmail.com> wrote:
> 
>> phantom, add a new driver
[...]
>> +static struct pci_driver phantom_pci_driver = {
>> +	.name = "phantom",
>> +	.id_table = phantom_pci_tbl,
>> +	.probe = phantom_probe,
>> +	.remove = __devexit_p(phantom_remove),
>> +	.suspend = phantom_suspend,
>> +	.resume = phantom_resume
>> +};
> 
> This goes into the read/write section.  Make it const?

Hmm, good question, I don't know the answer. Why are not pci_driver structs
const, Greg?

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
