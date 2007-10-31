Return-Path: <linux-kernel-owner+w=401wt.eu-S1759817AbXJaRTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759817AbXJaRTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 13:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755797AbXJaRTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 13:19:12 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:40061 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201AbXJaRTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 13:19:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=htK73S5ftujMsTEaiviLyRwE6vjsnnrHSB6lfF+tjJ1cwiIInzznTsGGZD8ez2m3sBIy7eMZbTUZzV1M3zgQKViGt6AnKwu9Wkgd4vF35ijJaVpGrWtHLplUTtc8yAHYzOnWpSLauboDSnVF9vdcEKFvW41RJO9NfVZ0et8fO8I=
Message-ID: <e9e943910710311019o519868e1h113fa6908a97b7bf@mail.gmail.com>
Date: Wed, 31 Oct 2007 17:19:09 +0000
From: "Duane Griffin" <duaneg@dghda.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: 2.6.23 regression: accessing invalid mmap'ed memory from gdb causes unkillable spinning
Cc: "Nick Piggin" <npiggin@suse.de>,
       "linux-kernel Mailing List" <linux-kernel@vger.kernel.org>,
       stable@kernel.org
In-Reply-To: <alpine.LFD.0.999.0710310854560.3340@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e9e943910710301745u429b14fj6c5a66fcbf6b0efa@mail.gmail.com>
	 <20071031041932.GA12189@wotan.suse.de>
	 <alpine.LFD.0.999.0710310756220.30120@woody.linux-foundation.org>
	 <20071031151934.GA19211@wotan.suse.de>
	 <alpine.LFD.0.999.0710310854560.3340@woody.linux-foundation.org>
X-Google-Sender-Auth: b851efc797ca89eb
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/10/2007, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> But I just rebooted and tested - the cleaned-up patch does seem to work
> fine, and I get "Cannot access memory at address <xyz>" rather than any
> reported problem.

I can confirm the same thing here, FWIW.

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
