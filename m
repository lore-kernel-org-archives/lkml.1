Return-Path: <linux-kernel-owner+w=401wt.eu-S1753495AbZHZUvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbZHZUvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 16:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753017AbZHZUvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 16:51:42 -0400
Received: from mail-qy0-f198.google.com ([209.85.221.198]:40100 "EHLO
	mail-qy0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbZHZUvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 16:51:41 -0400
X-Greylist: delayed 379 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Aug 2009 16:51:41 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CkwDDuaK/3DlxcO+S+7e5kcN+Ww9KmstLtPHuGric+7/rJL8hV2qNMH+8lCvdxudZS
         KproAEwZC38rUJok4qqBeltjyvUORmSH+RdR6JspTk1HxnyJ7FHiMsbGMxL0BXckpvVQ
         3ng0o7+W2RX2SUPONP74MAPaAx+LxE4opEhRU=
MIME-Version: 1.0
In-Reply-To: <689eb3470908261328m51e00168x144cf4c7241051f3@mail.gmail.com>
References: <689eb3470908242336o6681b516uc21d07979099d8c8@mail.gmail.com>
	 <alpine.LRH.2.00.0908251443230.11692@twin.jikos.cz>
	 <689eb3470908261328m51e00168x144cf4c7241051f3@mail.gmail.com>
Date: Wed, 26 Aug 2009 13:45:24 -0700
Message-ID: <689eb3470908261345r42ca80cq28c767433ba51299@mail.gmail.com>
Subject: Re: All pages belonging to a process
From: Anupama Chandwani <anupama.chandwani@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> Do you have mmap_sem locked?
>
> I didnt, but that didnt solve the problem.
>

The problem was when the "pte" was not present, due to no page for the
corresponding pte.
After handling that condition, it works fine.

Thanks Jiri for your help.


-- 
Cheers,
Anupama Chandwani
