Return-Path: <linux-kernel-owner+w=401wt.eu-S1751521AbZLMGKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521AbZLMGKx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 01:10:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbZLMGKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 01:10:52 -0500
Received: from claw.goop.org ([74.207.240.146]:44537 "HELO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751361AbZLMGKw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 01:10:52 -0500
Message-ID: <4B24856A.4020507@goop.org>
Date: Sat, 12 Dec 2009 22:10:50 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091203 Fedora/3.0-3.13.rc2.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Poor KVM guest performance on an HP rack server
References: <4B243B2B.806@pardus.org.tr>
In-Reply-To: <4B243B2B.806@pardus.org.tr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/09 16:54, Ozan Çağlayan wrote:
> We have an HP Proliant DL580G5 rack server. It has 4 Intel Xeon X7460(6
> core, 2.67GHz, 16MB L3) processor with 32GB of memory. /proc/cpuinfo has
> 24 x the following entry:
>
>
>
> I'm running 2.6.30.9-pae on top of it. We were actually planning to use
> it for a virtualization server for giving people dedicated *guest*
> access for their personal compile-farm needs.
>    

Why are you running a 32-bit kernel on this machine?  Sounds like a bad 
mismatch.

     J
