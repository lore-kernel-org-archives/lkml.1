Return-Path: <linux-kernel-owner+w=401wt.eu-S1758063AbYJPRoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063AbYJPRoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755183AbYJPRn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:43:58 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:14069 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146AbYJPRn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:43:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=dJpOfvqaYk5KbH26BWd9G4yFZfGofL7SWinpS9jz1Y2LpEYyV824aqGLkYpi6cyLkG
         B0NLTBgYw+fUcV5I8zFOu4BIRzS1rdT0191WNj4dK1xdLP76JMafHtwVRpZDX62yTANQ
         FlBjH6tfuqjX6JBywO2R8fTeBfn6evfhQKxik=
Message-ID: <86802c440810161043k4c4bf6e6x4f5a70c54c53ca3b@mail.gmail.com>
Date: Thu, 16 Oct 2008 10:43:56 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: bob.montgomery@hp.com
Subject: Re: [PATCH] disable CPU side GART accesses
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "vojtech@suse.cz" <vojtech@suse.cz>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "chandru@in.ibm.com" <chandru@in.ibm.com>,
       "Joerg Roedel" <joerg.roedel@amd.com>,
       "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Pavel Machek" <pavel@ucw.cz>
In-Reply-To: <1224176445.2215.258.camel@amd.troyhebe>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1224107317.2215.238.camel@amd.troyhebe>
	 <20081015234842.GA10999@elte.hu> <48F68940.40409@kernel.org>
	 <1224176445.2215.258.camel@amd.troyhebe>
X-Google-Sender-Auth: b0a0b6d71cc8e77f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 10:00 AM, Bob Montgomery <bob.montgomery@hp.com> wrote:
>
> The problem occurs when the copy operation reads from the GART aperture
> (iommu window) and wakes up the GART translation hardware.  This patch
> stops that by telling the GART to ignore addresses that come from the
> CPU and to only translate addresses from the IO side.

why kdump need to copy those area? those area is supposed to be
reserved in e820 table by BIOS or first kernel.

YH
