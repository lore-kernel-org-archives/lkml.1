Return-Path: <linux-kernel-owner+w=401wt.eu-S1754920AbZGAVp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbZGAVp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 17:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753387AbZGAVpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 17:45:17 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:54670 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbZGAVpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 17:45:16 -0400
Date: Wed, 1 Jul 2009 23:45:15 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-input@vger.kernel.org, jbarnes@virtuousgeek.org
Subject: Re: [PATCH 2/2] Add a driver for the Winbond WPCD376I IR
 functionality.
Message-ID: <20090701214515.GA5946@hardeman.nu>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
	linux-input@vger.kernel.org, jbarnes@virtuousgeek.org
References: <1246079912-17619-1-git-send-email-david@hardeman.nu>
 <1246079912-17619-3-git-send-email-david@hardeman.nu>
 <20090630142345.58e97b50.akpm@linux-foundation.org>
 <35c700707581a42af21dd9edc82a5e84.squirrel@www.hardeman.nu>
 <20090701110616.60c05a5d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090701110616.60c05a5d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 11:06:16AM -0700, Andrew Morton wrote:
>On Wed, 1 Jul 2009 09:47:46 +0200 (CEST)
>David Härdeman <david@hardeman.nu> wrote:
>>> Something has gone wrong with the types here.  Where does the fault lie
>>> - this driver, or input core?
>>
>> Two issues:
>>
>> a) the input layer API confused me
>> ...
>> b) 32 bit scancodes
>> ...
>
>erp.  Hopefully this is all something which Dmitry can help us with.

I'll wait for feedback from Bjorn Helgaas and Dmitry, meanwhile I've 
updated the patch to (hopefully) fix all the other issues you've raised, 
I'll send it in a separate mail.

-- 
David Härdeman
