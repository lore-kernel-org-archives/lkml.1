Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab0CIMGa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 07:06:30 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:37530 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab0CIMG2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 07:06:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=IYcsz9oPTQsEaNN72RDmh6xN2SRBhs82Rjmf3CIhJBVqErnReOeWuxtmVP2eJQ8MVr
         UO2zeuDSuZcbjxY9UsaON0MImQuEUeR8byHP0yA3bY0ezf73pTaTzh/uSGxz6yYumnHu
         +Z0Vz1XuGqyXnTgixftEX3LIXyMt7sLO2eWgE=
MIME-Version: 1.0
In-Reply-To: <4B95FB06.6070906@kernel.org>
References: <2fcd155e7b67ba2d41de0a5a0751b3091bf849d8.1267785770.git.andre.goddard@gmail.com> 
	<4B95FB06.6070906@kernel.org>
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Tue, 9 Mar 2010 08:58:08 -0300
Message-ID: <b8bf37781003090358y9e28db4v15497543ad14c5fc@mail.gmail.com>
Subject: Re: [PATCH] sysfs/file: move NULL checks to where they make sense and 
	can occur
To: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Alex Chiang <achiang@hp.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Serge Hallyn <serue@us.ibm.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> On 03/05/2010 07:46 PM, André Goddard Rosa wrote:
>> ... avoiding checking for NULL 2 times in a row when we already have a page.
>>
>> It decreases code size:
>> text    data     bss     dec     hex filename
>> 4246      48    4136    8430    20ee fs/sysfs/file-BEFORE.o
>> 4214      48    4136    8398    20ce fs/sysfs/file-AFTER.o
>>
>> Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
>
> Nacked-by: Tejun Heo <tj@kernel.org>
>
> For this level of micro optimization to be meaningful, the code path
> should be *really* *really* hot, which none of sysfs code pats are.
> Whatever is easier to the eyes wins.
>

    Ok Tejun, I understood your point of view.

Thanks,
André
