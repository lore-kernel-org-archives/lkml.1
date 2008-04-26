Return-Path: <linux-kernel-owner+w=401wt.eu-S1761954AbYDZVGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761954AbYDZVGs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 17:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758009AbYDZVGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 17:06:38 -0400
Received: from rv-out-0708.google.com ([209.85.198.248]:23948 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753881AbYDZVGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 17:06:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=QrtDNeKLG2/C17b9XsuQa5kXQcHPJwDEuw3GbiRBpq3/ayiISTG64ey+reEHnqC+KUm+j/dCH03bG/7ssHE3OcT5qMH2rG/4QtWLZKHdGI/zCtQ2LRofsYSBenwguDTiKhdUt9E/v7D28ZNvSkFsoN8JrxsUce9+8RZXuiWFh7g=
Message-ID: <b6c5339f0804261406o447b95b2i18c937a6c738f8db@mail.gmail.com>
Date: Sat, 26 Apr 2008 17:06:35 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: spinlock lockup on CPU#0
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Justin Mattock" <justinmattock@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>
In-Reply-To: <20080426191432.GA2927@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30804231841m3bbfab44x53d635b7ea6fc58d@mail.gmail.com>
	 <20080426112907.77613dee.akpm@linux-foundation.org>
	 <20080426191432.GA2927@elte.hu>
X-Google-Sender-Auth: 97aac2e4f39b5ae8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 3:14 PM, Ingo Molnar <mingo@elte.hu> wrote:
>  > Can you add this please, see if it triggers?
>
>  there's fixes pending in this area. The main fix would be the one below.
>
>         Ingo
>
>  ---------------->
>  Subject: idle (arch, acpi and apm) and lockdep

FWIW, I was seeing the same lockdep trace with eventual hangs, and
this patch (applied with some fuzz) fixed the problem.

-- 
Bob Copeland %% www.bobcopeland.com
