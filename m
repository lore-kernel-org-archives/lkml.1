Return-Path: <linux-kernel-owner+w=401wt.eu-S1753279AbZGAHeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbZGAHeH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 03:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbZGAHd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 03:33:56 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:48894 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbZGAHdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 03:33:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=UMr6zF+Uy5/NIijneHJd0nxXvdjMPhUGswhmrbNTpf/1qzJbulCvcsUAGbZv+Wv7Uc
         BTUxdzPSCdWqQoeBAcJEcMECf8gYWSEFns/9JwxcF+0oYvhC5Tke+T8wAD7xdwhUwFEG
         4rMWn9iCEtfxK6bujOpY5m4bmc2dW8SKjO+iE=
Message-ID: <4A4B115A.5080903@gmail.com>
Date: Wed, 01 Jul 2009 09:33:46 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.7 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Daniel Ribeiro <drwyrm@gmail.com>
CC: sameo@linux.intel.com, laforge@openezx.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MFD: ezx-pcap, fix lock imbalance
References: <1246431187-23684-1-git-send-email-jirislaby@gmail.com> <1246431871.19661.8.camel@brutus>
In-Reply-To: <1246431871.19661.8.camel@brutus>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2009 09:04 AM, Daniel Ribeiro wrote:
> Em Qua, 2009-07-01 às 08:53 +0200, Jiri Slaby escreveu:
>> There is an omitted unlock in pcap_adc_irq ISR on one fail path. Fix that.
>>
>> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> 
> I would be happy to ack this, however, you are late. ;)

Heh :), nevermind.
