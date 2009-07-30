Return-Path: <linux-kernel-owner+w=401wt.eu-S1752385AbZG3J4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385AbZG3J4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 05:56:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbZG3J4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 05:56:06 -0400
Received: from cpsmtpm-eml103.kpnxchange.com ([195.121.3.7]:54790 "EHLO
	CPSMTPM-EML103.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752293AbZG3J4F convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 05:56:05 -0400
From: Frans Pop <elendil@planet.nl>
To: =?utf-8?q?C=C3=A9dric_Godin?= <cedric@belbone.be>,
       linux-kernel@vger.kernel.org
Subject: Re: [Bug 13865] Can only resume with HP_WMI selected on compaq nc6000 when 4c395bdd3f2ca8f7e8efad881e16071182c3b8ca is reverted
Date: Thu, 30 Jul 2009 11:56:01 +0200
User-Agent: KMail/1.9.9
Cc: bugzilla-daemon@bugzilla.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>
References: <bug-13865-10028@http.bugzilla.kernel.org/> <200907292331.34214.elendil@planet.nl> <4A7165D8.8060705@belbone.be>
In-Reply-To: <4A7165D8.8060705@belbone.be>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200907301156.03248.elendil@planet.nl>
X-OriginalArrivalTime: 30 Jul 2009 09:56:03.0490 (UTC) FILETIME=[F31A4020:01CA10FB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 July 2009, Cédric Godin wrote:
> > The strange thing is that the resume function does not do anything
> > that's not also done in hp_wmi_input_setup(). The only thing I can
> > think of is that we might need to test for
> > wmi_has_guid(HPWMI_EVENT_GUID) because that model simply does not
> > support input events.
>
> I tested your patch (from buzilla) and now I can resume.

Great.

> Thanks ! You have my tested-by ;-)
>
> PS: I suppose you don't need this infos anymore ?

I'd still like to see the following if it's not too much trouble, 
basically to confirm that the theory was indeed correct.

$ grep . /sys/devices/platform/hp-wmi/*
$ cat /proc/bus/input/devices

Thanks,
FJP
