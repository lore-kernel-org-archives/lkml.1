Return-Path: <linux-kernel-owner+w=401wt.eu-S1756391AbYJ3OBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391AbYJ3OBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 10:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754798AbYJ3OB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 10:01:29 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:64271 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133AbYJ3OB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 10:01:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=KflSzn3odZ6pybTC8p775poUZIkv+diYZAfOrIVS5nOSsHig7CWiw6Ma6Zi7N7aLDs
         3yjMeBB+4L1bP0gyZaJRuY9vxYPuD7T47OWcZV2KcaL6dqkVmYHqYyycVrVwqVW819he
         MS/bTTtGho+jATIKbX+4ixdwVfIcXHh3lNPHg=
Message-ID: <f17812d70810300701g68c84246n1f6e3f1abe9d651b@mail.gmail.com>
Date: Thu, 30 Oct 2008 22:01:26 +0800
From: "Eric Miao" <eric.y.miao@gmail.com>
To: "Mike Rapoport" <mike@compulab.co.il>
Subject: Re: [LED bug fix] leds-da903x (da9030 only) led brightness reversed.
Cc: "Jonathan Cameron" <Jonathan.Cameron@gmail.com>, rpurdie@rpsys.net,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4909A04D.2090404@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <490994DC.7040409@gmail.com> <4909A04D.2090404@compulab.co.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 7:53 PM, Mike Rapoport <mike@compulab.co.il> wrote:
>
>
> Jonathan Cameron wrote:
>> The brightness control register calculation (for the pwm) is
>> effectively the reverse of what would be expected.
>> 1 is maximum brightness, 255 minimum.
>>
>> This patch inverts this.
>>
>> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
>
> Acked-by: Mike Rapoport <mike@compulab.co.il>
>

OK, queued.

Richard, I'm taking this patch along with some of my other
fixes to be pushed out tonight, thanks.
