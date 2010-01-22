Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975Ab0AVEyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab0AVEyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 23:54:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753767Ab0AVEya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 23:54:30 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:58058 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab0AVEyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 23:54:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=sroNCCmVC1DyvZ2kK3zVXMrrDoyrXVR8e6EJrJwCmRZ0qpJ+iBKJc1sk6lN2YulYWt
         X+ZZz+lTJyEqWR0M5mbXs8MDCJzb/MmSmnF42B/35zy+WZGxdGFDathoNRUSwzEciFlw
         OKBd76jd0qhrtaJmqtgdVh4dRyvPhtxgcjP2k=
From: Don Mullis <don.mullis@gmail.com>
To: Olaf Titz <olaf@bigred.inka.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] lib: revise list_sort() comment
References: <87fx609i29.fsf@gmail.com> <877hrc9guw.fsf@gmail.com>
	<E1NY2R2-0007nJ-Ic@bigred.inka.de>
Date: Thu, 21 Jan 2010 20:54:07 -0800
In-Reply-To: <E1NY2R2-0007nJ-Ic@bigred.inka.de> (Olaf Titz's message of "Thu,
	21 Jan 2010 20:11:16 +0100")
Message-ID: <87r5pi91u8.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olaf Titz <olaf@bigred.inka.de> writes:

>> + * The comparison function @cmp must return a negative value if @a
>> + * should sort before @b, and a positive value if @a should sort after
>> + * @b. If @a and @b are equivalent, and their original relative
>> + * ordering is to be preserved, @cmp should return 0; otherwise, the
>> + * return value does not matter.
>
> This "otherwise... does not matter" sounds funny and confusing. Either
> read this as "the return value does not matter if it is neither <0, >0
> or ==0" or "the return value does not matter if the function wants it
> to be ignored". :-)
>
> Just omitting the "otherwise" clause would be clearer.
>
> Olaf

Okay, I will simplify the wording.

