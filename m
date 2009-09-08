Return-Path: <linux-kernel-owner+w=401wt.eu-S1752145AbZIHT61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbZIHT61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 15:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbZIHT60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 15:58:26 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:35764 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbZIHT6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 15:58:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=qmXgiUFApkD7gU9OTxkmtnEc9ZjsepH64l4WpClUvT5rs7edTf1EQ/M7A975f/zysY
         1jq2W8at4fpIq5srlHEk29fQmSmNkq2MTCHTtcieP5aFFcV7wWh3w1Id8AzygQmoKZY9
         n0lkClskGvOgJ8ZUa3iPybiJ5tWAe5DIhkpRg=
Message-ID: <4AA6B5D4.4040802@gmail.com>
Date: Tue, 08 Sep 2009 21:51:48 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux.kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [Bug #13733] 2.6.31-rc2: irq 16: nobody cared
References: <dhwns-J2-13@gated-at.bofh.it> <dhwxb-O6-7@gated-at.bofh.it>
In-Reply-To: <dhwxb-O6-7@gated-at.bofh.it>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2009 10:30 PM, Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13733
> Subject		: 2.6.31-rc2: irq 16: nobody cared
> Submitter	: Niel Lambrechts<niel.lambrechts@gmail.com>
> Date		: 2009-07-06 18:32 (63 days old)
> References	: http://marc.info/?l=linux-kernel&m=124690524027166&w=4

Hi Rafael,

This is still present in 2.6.31-rc9-pae.

To test, I removed ehci_hcd, hibernated/resumed and the problem did not appear. But when I first plugged in a USB mouse after the system was up and before ehci_hcd was loaded the error occurred again.

Regards,
Niel
