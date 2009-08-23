Return-Path: <linux-kernel-owner+w=401wt.eu-S933972AbZHWQvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933972AbZHWQvV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 12:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933947AbZHWQvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 12:51:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:56227 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933938AbZHWQvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 12:51:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:newsgroups:to
         :cc:subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=N8ecPc+vy+oMh137mj5xPod3AtqZlDUxbOkih3+5ujngYAt458ZQy+RdG8pzwK1dPr
         6wm6sjh0ptC1G4BoLOrbtFvC58SNA7z5KD6CLYCpCtiTkhLhLkf8WgiCzlollamRBr9U
         Sf2gFnhwtdOsiP3R8riSbEwTE+ogtAbKsjizg=
Message-ID: <4A91737E.5080807@gnu.org>
Date: Sun, 23 Aug 2009 18:51:10 +0200
From: Paolo Bonzini <bonzini@gnu.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
Newsgroups: gmane.comp.emulators.kvm.devel,gmane.linux.kernel
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Davide Libenzi <davidel@xmailserver.org>,
       gleb@redhat.com, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] eventfd: new EFD_STATE flag
References: <20090820155655.GA8764@redhat.com> <alpine.DEB.2.00.0908200916300.14844@makko.or.mcafeemobile.com> <4A8D8A28.2050004@redhat.com> <20090820175540.GA9232@redhat.com> <4A8D90BB.2030506@redhat.com> <20090820182847.GB9282@redhat.com> <4A913DA9.1020403@redhat.com> <20090823133620.GA12841@redhat.com> <4A9146E3.2090007@redhat.com> <20090823143021.GA27495@redhat.com>
In-Reply-To: <20090823143021.GA27495@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2009 04:30 PM, Michael S. Tsirkin wrote:
> On Sun, Aug 23, 2009 at 04:40:51PM +0300, Avi Kivity wrote:
>> On 08/23/2009 04:36 PM, Michael S. Tsirkin wrote:
>>> More important here is realization that eventfd is a mutex/semaphore
>>> implementation, not a generic event reporting interface as we are trying
>>> to use it.
>>>
>>
>> Well it is a generic event reporting interface (for example, aio uses it).
>
> Davide, I think it's a valid point.  For example, what read on eventfd
> does (zero a counter and return) is not like any semaphore I saw.

It is similar to Win32 events (which can be used like contorted mutexes 
to sync two processes).

Paolo
