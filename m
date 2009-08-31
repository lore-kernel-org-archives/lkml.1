Return-Path: <linux-kernel-owner+w=401wt.eu-S1751858AbZHaIOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858AbZHaIOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 04:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217AbZHaIOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 04:14:30 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:49882 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbZHaIO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 04:14:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=sq+WX5hcdoaYuWvb6pPcJ1GjY9fGq2X+NWuOgNjItDdgRqi08eT/81vLIhFcUBK9wl
         fHotQUi4HRHhMVG2yuuLped4ejWtH8YPcGNPcAXl2QKAFGeHc46FxZWxcpYLUX+FAJoZ
         M72XnPn30Q31mdUb5nSI9XXuUcA5tuuCEmO24=
Date: Mon, 31 Aug 2009 10:14:26 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, kjwinchester@gmail.com,
       tglx@linutronix.de, borislav.petkov@amd.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH 3/3] x86, AMD: Disable wrongly set X86_FEATURE_LAHF_LM
 CPUID bit
Message-ID: <20090831081426.GA2876@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	"H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com,
	linux-kernel@vger.kernel.org, kjwinchester@gmail.com,
	tglx@linutronix.de, borislav.petkov@amd.com,
	linux-tip-commits@vger.kernel.org
References: <1251633031-2244-1-git-send-email-petkovbb@gmail.com>
 <1251633031-2244-3-git-send-email-petkovbb@gmail.com>
 <4A9AD17A.6060507@zytor.com>
 <20090830193039.GB22234@liondog.tnic>
 <4A9ADAC3.3020004@zytor.com>
 <20090830202926.GC22234@liondog.tnic>
 <4A9AE5B1.80305@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4A9AE5B1.80305@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 30, 2009 at 01:48:49PM -0700, H. Peter Anvin wrote:
> The 2x32 bit interface is the legacy interface.  It turned out to be a
> bad idea, but it's hard to clean up all the users.

By the way, do we want to switch all rd/wrmsr users to the rd/wrmsrl et
al interfaces? I could do that gradually - there are only about 400+
callsites :)

-- 
Regards/Gruss,
    Boris.
