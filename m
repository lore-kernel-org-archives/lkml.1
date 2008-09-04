Return-Path: <linux-kernel-owner+w=401wt.eu-S1756864AbYIDIuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864AbYIDIuJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 04:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752243AbYIDIt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 04:49:57 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:33539 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbYIDIt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 04:49:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ac73TmPGPDz/qe0cb+NrMNb0lok95/5LgOkqdUeCjSlZ/l/+p0DyPv0ovGgTOxb/oY
         4iCStCu2pQ3f3sSdPlRPSjuHhZj3c86zTRdFF9FBEqqY562DDnyIG734I90PM8lfqWOD
         ieF7+nwEksAt9VjQs2Gsm/DNvb3q2udUVGLzY=
Message-ID: <38b2ab8a0809040149u2bc0342h5c32b87f9277322f@mail.gmail.com>
Date: Thu, 4 Sep 2008 10:49:55 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: qestion about I2C_CLASS_HWMON flag
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       i2c@lm-sensors.org
In-Reply-To: <20080904103707.557ac764@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0809040043g7f944872l47f84c53bb213829@mail.gmail.com>
	 <38b2ab8a0809040105j7ae3aca8xd334a4d203d9415b@mail.gmail.com>
	 <20080904103707.557ac764@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 4, 2008 at 10:37 AM, Jean Delvare <khali@linux-fr.org> wrote:
> Hi Francis,
>
> On Thu, Sep 4, 2008 at 9:43 AM, Francis Moreau <francis.moro@gmail.com> wrote:
>> I'm wondering why does this flag exist ?
>>
>> Why is a hw monitor device so special so that an I2C bus needs
>> a flag to tell the rest of the world that it support it ?
>
> I don't understand your point. We have I2C_CLASS flags for many I2C
> device types (analog TV, digital TV, etc.) I2C_CLASS_HWMON isn't the
> exception you describe. Look at <linux/i2c.h> for a list of these flags.
>

My question (sorry if that silly) is why do we need these flags at all ?

Can't I2C bus address any kinds of I2C devices ?

What make hwmon devices special so that some I2C adapter can't
talk to them ?

Thanks
-- 
Francis
