Return-Path: <linux-kernel-owner+w=401wt.eu-S1754862AbZBWBwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbZBWBwV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 20:52:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbZBWBwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 20:52:12 -0500
Received: from smtp106.prem.mail.sp1.yahoo.com ([98.136.44.61]:22880 "HELO
	smtp106.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752071AbZBWBwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 20:52:11 -0500
X-YMail-OSG: Iz.A18wVM1lSgghpjUg5AE.FN9F8Bzm7f8tzW0q5ZxBcDg07a6rz8frXASQ7UuGEhiZZAlIzYTMc90mVFUNHioSC_XYncalRaapvubBoF9VD_QAfYxD.s53q3pm8bY8Oc_wJ0UVz6HSkGO_SQlsZ7mBG9_yVqpdjrZdtu44dpiUJ7dpk5bXhQgRJEOmuDrxxQI4vtSP.lqSqv2Sn.W_dhgHlyw2KffZse8JzI0TFMHBM_JfWwUPwYc3bR3j2kYuVAg86CDyqEaiQg8wz__0hmq1mjzs_TMTxY4Z6H6dr4Ha3wF.hX9LQqLptpQmLR9k-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <49A2013A.6020508@schaufler-ca.com>
Date: Sun, 22 Feb 2009 17:51:54 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: etienne <etienne.basset@numericable.fr>
CC: Paul Moore <paul.moore@hp.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       LSM <linux-security-module@vger.kernel.org>, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH][SMACK] convert smack_known list to a standard linux list.
References: <49A1C895.5030803@numericable.fr>
In-Reply-To: <49A1C895.5030803@numericable.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

etienne wrote:
> hello,
>
> this patch on top of [PATCH][SMACK] convert smack rule list to linux list V2
> converts "smack_known" to a regular linux list. (rcu variant)
>
>   

I'm having some trouble applying this group of patches.
I assume that I'm starting at the wrong place. Could you
do a single patch to help me avoid confusion?

Thank you.

> regards,
> Etienne
>
> Signed-off-by: <etienne.basset@numericable.fr>
> ---
> diff --git a/security/smack/smack.h b/security/smack/smack.h
> index 0dcb907..64164f8 100644
> --- a/security/smack/smack.h
> +++ b/security/smack/smack.h
> @@ -109,7 +109,6 @@ struct smk_netlbladdr {
>   */
>  


