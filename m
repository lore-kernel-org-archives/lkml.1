Return-Path: <linux-kernel-owner+w=401wt.eu-S1755397AbZITS0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397AbZITS0K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 14:26:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755234AbZITS0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 14:26:09 -0400
Received: from mail-yw0-f173.google.com ([209.85.211.173]:39874 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087AbZITS0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 14:26:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=CE3OZDEVCf7Mua3lrlLh1QFVHlpANNTHOoO+kOey5kiUP4kqPiVvCJlHZODsfNTlj0
         OgiTwwZjktwckFbmu4HJmN6of3vAS6FiFvJ7HlRFP+TmJN36HYI9fkRxApV6NGMwKm/B
         edxpqECvOATZugTuL7F8psDFBKXK5vpNdoHKo=
Message-ID: <4AB673C1.7020909@gmail.com>
Date: Sun, 20 Sep 2009 12:26:09 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Junhee Lee <junhee@netsys.kaist.ac.kr>
CC: linux-kernel@vger.kernel.org
Subject: Re: microsecond event scheduling in an application
References: <015f01ca3090$85e8a280$91b9e780$@kaist.ac.kr>
In-Reply-To: <015f01ca3090$85e8a280$91b9e780$@kaist.ac.kr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2009 08:27 AM, Junhee Lee wrote:
> I am working on event scheduler which handles events in microsecond level.
> Actual this program is a network emulator using simulation codes.
> I'd like to expect that network emulator is working as simulation behaviors.
> Thus high resolution timer interrupt is required.
> But high resolution timer interrupt derived by high tick frequency (jiffies
> clock) must effect the system performance.
> Are there any comments or ways to support microsecond event scheduling
> without performance degradation?

Just increasing HZ will degrade performance, yes, but we have hrtimers 
now which should be able to use granularities smaller than one jiffy, so 
it shouldn't be needed..
