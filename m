Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305Ab0AEIZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab0AEIZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 03:25:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754202Ab0AEIZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 03:25:44 -0500
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:59341 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753945Ab0AEIZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 03:25:43 -0500
X-Greylist: delayed 1363 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jan 2010 03:25:42 EST
Message-ID: <4B42F226.6010207@st.com>
Date: Tue, 05 Jan 2010 09:02:46 +0100
From: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH] drivers/net/stmmac/gmac.c: use %pM to show MAC address
References: <BD79186B4FD85F4B8E60E381CAEE19090200F674@mi8nycmail19.Mi8.com>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE19090200F674@mi8nycmail19.Mi8.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Hartley,

H Hartley Sweeten wrote:
> Use the %pM kernel extension to display the MAC address.

Thanks for this patch.
As discussed in the mailing list, I'm reworking some patches for the
stmmac driver (fixing compilation errors and trying to make the code
more generic).
I've already modified the gmac.c file now splitted in new two files.
So I'm wondering if it's worth applying this patch into the new code,
directly.

Regards,
Peppe

> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: David S. Miller <davem@davemloft.net>
> ---
> 
> diff --git a/drivers/net/stmmac/gmac.c b/drivers/net/stmmac/gmac.c
> index 52586ee..7700772 100644
> --- a/drivers/net/stmmac/gmac.c
> +++ b/drivers/net/stmmac/gmac.c
> @@ -481,12 +481,8 @@ static void gmac_set_filter(struct net_device *dev)
>  				gmac_set_umac_addr(ioaddr, uc_ptr->da_addr,
>  						i + 1);
>  
> -				DBG(KERN_INFO "\t%d "
> -				"- Unicast addr %02x:%02x:%02x:%02x:%02x:"
> -				"%02x\n", i + 1,
> -				uc_ptr->da_addr[0], uc_ptr->da_addr[1],
> -				uc_ptr->da_addr[2], uc_ptr->da_addr[3],
> -				uc_ptr->da_addr[4], uc_ptr->da_addr[5]);
> +				DBG(KERN_INFO "\t%d - Unicast addr %pM\n",
> +					i + 1, uc_ptr->da_addr);
>  				uc_ptr = uc_ptr->next;
>  		}
>  	} 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAktC8iAACgkQ2Xo3j31MSSJ+DACguvgHAeRm2Qy+N6Lw8svt/nna
Z0sAnRjHHkG+FYtyu0OfjOrRi8eu9SyN
=srnl
-----END PGP SIGNATURE-----
