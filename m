Return-Path: <linux-kernel-owner+w=401wt.eu-S1757531AbYLKUZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531AbYLKUZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 15:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbYLKUZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 15:25:08 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:22230 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbYLKUZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 15:25:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=jAhTnUPGbTIBYiIAW7aIA8JI6zxIy+WVkrXOiDAI25hT+G3IQcZ7laAL/qKMw3CrdX
         1TYdOHLb+onG3dd1tBi9gKzczDNRN5asG0jJegC6KRvxOXVApXhZzRSeaUa983/jw98a
         ZJ6Dj5fMqtMJOt6s2SZf+Tn2JtJfWJQwtD2T4=
Message-ID: <e9e943910812111225o700afd2crc72e3aab4053fa72@mail.gmail.com>
Date: Thu, 11 Dec 2008 20:25:03 +0000
From: "Duane Griffin" <duaneg@dghda.com>
To: "Matthew Wilcox" <matthew@wil.cx>
Subject: Re: [PATCH] ext2: ensure link targets are NULL-terminated
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "Boaz Harrosh" <bharrosh@panasas.com>, linux-ext4@vger.kernel.org
In-Reply-To: <20081211192158.GE26095@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1229022995-9898-1-git-send-email-duaneg@dghda.com>
	 <1229022995-9898-2-git-send-email-duaneg@dghda.com>
	 <1229022995-9898-3-git-send-email-duaneg@dghda.com>
	 <1229022995-9898-4-git-send-email-duaneg@dghda.com>
	 <1229022995-9898-5-git-send-email-duaneg@dghda.com>
	 <20081211192158.GE26095@parisc-linux.org>
X-Google-Sender-Auth: ea416ea9b27b48ca
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/11 Matthew Wilcox <matthew@wil.cx>:
> On Thu, Dec 11, 2008 at 07:16:28PM +0000, Duane Griffin wrote:
>> Ensure link targets are NULL-terminated, even if corrupted on-disk.
>
> FWIW, that's spelled 'NUL' -- NULL is a pointer value, NUL is an ASCII
> code.

Good point, thanks. I'll try to remember for the future!

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
