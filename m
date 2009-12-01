Return-Path: <linux-kernel-owner+w=401wt.eu-S1754726AbZLAXmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbZLAXmu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 18:42:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754629AbZLAXmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 18:42:49 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:36536 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693AbZLAXms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 18:42:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=LUtLmU2ow0k5EQQtN0df/I6RhoK2h7SrQHxgJXhds+FQthuNdXMUU6z4HqMbbIgV4k
         alTTkFJM+DOrxw5EYe/JEcgdmBrNXeHN1sIzlINvBBMRvIlyPOtXZ091NCSnTr9a/Pb8
         rUAc0IB1ylaIoxNaZ9dYNkh28bK5ODvSoYwLI=
Message-ID: <4B15A9FB.2030808@lwfinger.net>
Date: Tue, 01 Dec 2009 17:42:51 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>
Subject: Re: Kernel BUG during suspend to disk with 2.6.32-rc8-git3
References: <4B159EAC.1010006@lwfinger.net> <4B15A2F6.4020206@gmail.com>
In-Reply-To: <4B15A2F6.4020206@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2009 05:12 PM, Justin P. Mattock wrote:
> 
> 
> looks familiar with what I'm getting
> over here.
> bugreport: http://bugzilla.kernel.org/show_bug.cgi?id= 14483
> 
> at the bottom reverting that commit
> worked here(but still need to see
> what others say).

Reverting commit 138d15692bf76841f252d4b836a535cf5f9154e9 fixed the
problem on my computer. Thanks for the info.

Larry

