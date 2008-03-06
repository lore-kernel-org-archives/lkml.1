Return-Path: <linux-kernel-owner+w=401wt.eu-S1760088AbYCFTnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760088AbYCFTnm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 14:43:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755077AbYCFTnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 14:43:32 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:6946 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbYCFTnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 14:43:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:content-type:content-transfer-encoding:sender;
        b=Bu3SbT+Zol2MkDK3Cav7SenlHaBxRXDbrXNj1bfvI6drRt2sOQXlgln8EyoZ5+/+5+R+sNVSbpi71nHplpDmpLHU4HMqboCiui7cU3MdGbXInimu5H09MXaAB5ZNFf7tia+vTJ5F95vyJRR29qfPtTlXB/5nACRx8vfj9XTdpDA=
Message-ID: <47D0495F.2090109@gnu.org>
Date: Thu, 06 Mar 2008 20:43:27 +0100
From: Paolo Bonzini <bonzini@gnu.org>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: gcc@gcc.gnu.org, linux-kernel@vger.kernel.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction
    flag
References: <2F47E21A-9055-4EC3-99CF-B666BBC045C3@apple.com> <47CF3F09.4080606@zytor.com> <578FCA7D-D7A6-44F6-9310-4A97C13CDCBE@apple.com> <47CF44E7.3020106@zytor.com> <20080306135139.GA5236@dspnet.fr.eu.org> <47CFF9A3.30309@gnu.org> <20080306141221.GC5236@dspnet.fr.eu.org> <20080306175841.GI17267@synopsys.com> <20080306181029.GA42904@dspnet.fr.eu.org> <47D03440.6090503@gnu.org> <20080306183146.GL27983@randombit.net>
In-Reply-To: <20080306183146.GL27983@randombit.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jack Lloyd wrote:
> On Thu, Mar 06, 2008 at 07:13:20PM +0100, Paolo Bonzini wrote:
>> A process can send a signal via kill.  IOW, a malicious process can 
>> *control when the process would be interrupted* in order to get it into 
>> the signal handler with DF=1.
> 
> If the malicious process can send a signal to another process, it
> could also ptrace() it. Which is more useful, if you wanted to be
> malicious?

1) capabilities(7)

2) sometimes setuid programs send signals (e.g. SIGHUP or SIGUSR1)...

Paolo
